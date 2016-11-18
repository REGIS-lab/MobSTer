     /$$      /$$           /$$        /$$$$$$  /$$$$$$$$                 
    | $$$    /$$$          | $$       /$$__  $$|__  $$__/                 
    | $$$$  /$$$$  /$$$$$$ | $$$$$$$ | $$  \__/   | $$  /$$$$$$   /$$$$$$ 
    | $$ $$/$$ $$ /$$__  $$| $$__  $$|  $$$$$$    | $$ /$$__  $$ /$$__  $$
    | $$  $$$| $$| $$  \ $$| $$  \ $$ \____  $$   | $$| $$$$$$$$| $$  \__/
    | $$\  $ | $$| $$  | $$| $$  | $$ /$$  \ $$   | $$| $$_____/| $$      
    | $$ \/  | $$|  $$$$$$/| $$$$$$$/|  $$$$$$/   | $$|  $$$$$$$| $$      
    |__/     |__/ \______/ |_______/  \______/    |__/ \_______/|__/      
                                                                      
                                                                      
                                                                      
Model-based Security Testing Framework is a framework for model-based testing
the security of web application. MobSTer implements formal approaches in order
to test the security of web applications by helping the security analyst not
missing important security checks.


Dependencies
========================
MobSTer is a python tool that requires the following packages:
python2.7
TODO: test python3
    # pip install httplib2
    # pip install lxml
    # pip install requests

Morover MobSTer is shipped with the Alloy Analizer which requires Java in
order to be executed.



How does MobSTer work?
========================

![MobSTer framework](https://bitbucket.org/caioM/mobster/raw/master/framework.png  "MobSTer, a framework for model-based testing
of web applications (the arrows refer to interaction between elements or data
passed between them, the numbers are used in the text for the explanation of
the different phases).")

The first thing that a security analyst has to do when using our framework is
to define a formal model of the web application to test. This is done by
defining actions from the web application (phase 2 in Figure).  During this
phase, the security analyst has also to check, manually, if some of the
existing actions in the database can be reused in order to model the web
application (if two web applications share the same functionality, then she can
reuse the associated action), and, if not, she has to insert into the database
the new action(s).

With the database populated with a proper set of actions, the security analyst
has the means to create the model of the web application (2). The model
includes a subset of the defined actions (identified with respect to the web
application), the relation between them, and a specification of the security
goal to be tested.

The model is then passed to a model checker (3). Our framework is general and
thus it is not bound to a specific model-checking tool; for concreteness, in
our implementation of MobSTer, we employ the [Alloy Analizer](http://alloy.mit.edu/alloy/),
which takes a model and its security goal, checks the goal in the model and
generates one or more counterexamples if the goal is violated, i.e., a
counterexample shows for what instances of the system and for what actions the
security goal does not hold.

MobSTer provides for a concretization phase in order to test the output
provided by the Alloy Analizer, which relies on the fact that we can define for
each action a sequence of HTTP requests to perform on the web application. In
our implementation of MobSTer, the definition of the relations between actions
and HTTP requests (5) is performed during the execution of the test cases by a
Python engine.

Second, the counterexample(s) specify which actions have to be used, but their
level of abstraction does not allow for the specification of attack-dependent
data. If we have to use a specific payload, the Instantiation Library provides
it. The Instantiation Library contains data such as attack strings (e.g.,
payloads for XSS), common malicious input (e.g., a set of passwords for a
brute-force attack) and scripts to be used as test patterns (i.e., scripts to
be executed client-side in order to test the web application).

The final phase of the framework uses an automatic test-execution engine TEE
that the security analyst can employ in order to execute the test cases on the
web application. The TEE provides a connection with the Instantiation Library
and the data that is contained in the Configuration Values and is needed for
the interaction with the web application (4), and the TEE also takes care of
“translating” (via the Low-level Definition (5)) the counterexample(s) (4) into
executable test cases. At the end of this phase, the information contained in
the counterexample(s), the actions and the HTTP requests are combined in the
creation of a suite of test cases (6) that are run on the web application (7).

Further details about MobSTer and it's implementation can be found ![here](http://paper.link).
TODO: update link to paper


Examples
========================
TODO: add examples


