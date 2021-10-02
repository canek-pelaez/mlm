/*
 * This file is part of mlm.
 *
 * Copyright © 2009 Julien Peeters
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.

 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.

 * You should have received a copy of the GNU Lesser General Public License
 * along with this library. If not, see <http://www.gnu.org/licenses/>.
 *
 * Author:
 *    Julien Peeters <contact@julienpeeters.fr>
 */

namespace MLM.Test {

    /**
     * Base class for test cases.
     */
    public abstract class TestCase : GLib.Object {

        /* The test suite. */
        private GLib.TestSuite suite;
        /* Adaptors. */
        private Adaptor[] adaptors = new Adaptor[0];

        /**
         * Delegate for test methods.
         */
        public delegate void TestMethod();

        /**
         * Creates a new test case with a given name.
         * @param name the name of the test case.
         */
        protected TestCase(string name) {
            this.suite = new GLib.TestSuite(name);
        }

        /**
         * Add a test with a name.
         * @param name the name of the test.
         * @param test the test method.
         */
        public void add_test(string name, owned TestMethod test) {
            var adaptor = new Adaptor(name, (owned)test, this);
            this.adaptors += adaptor;

            this.suite.add(new GLib.TestCase(adaptor.name,
                                             adaptor.set_up,
                                             adaptor.run,
                                             adaptor.tear_down));
        }

        /**
         * Sets up the test.
         */
        public virtual void set_up() {}

        /**
         * Tears down the test.
         */
        public virtual void tear_down() {}

        /**
         * Returns the test suite.
         * @return the test suite.
         */
        public GLib.TestSuite get_suite() {
            return this.suite;
        }

        /* Adaptor auxiliary class. */
        private class Adaptor {

            /* The name. */
            [CCode (notify = false)]
            public string name { get; private set; }

            /* The test method. */
            private TestMethod test;
            /* The test case. */
            private TestCase test_case;

            /* Initializes an adaptor. */
            public Adaptor(string name,
                           owned TestMethod test,
                           TestCase test_case) {
                this.name = name;
                this.test = (owned)test;
                this.test_case = test_case;
            }

            /* Sets up the test case. */
            public void set_up(void* fixture) {
                this.test_case.set_up();
            }

            /* Runs the test method. */
            public void run(void* fixture) {
                this.test();
            }

            /* Tears down the test case. */
            public void tear_down(void* fixture) {
                this.test_case.tear_down();
            }
        }
    }
}
