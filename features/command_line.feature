Feature: Command Line
  In order to manage my stylesheets
  As a user on the command line
  I want to create a new project

  Scenario: Install a project without a framework
    When I create a project using: compass create my_project
    Then a directory my_project/ is created
    And a configuration file my_project/config.rb is created
    And a sass file my_project/src/screen.sass is created
    And a sass file my_project/src/print.sass is created
    And a sass file my_project/src/ie.sass is created
    And a sass file my_project/src/screen.sass is compiled
    And a sass file my_project/src/print.sass is compiled
    And a sass file my_project/src/ie.sass is compiled
    And a css file my_project/stylesheets/screen.css is created
    And a css file my_project/stylesheets/print.css is created
    And a css file my_project/stylesheets/ie.css is created
    And I am told how to link to /stylesheets/screen.css for media "screen, projection"
    And I am told how to link to /stylesheets/print.css for media "print"
    And I am told how to conditionally link "IE" to /stylesheets/ie.css for media "screen, projection"

  Scenario: Install a project with blueprint
    When I create a project using: compass create bp_project --using blueprint
    Then a directory bp_project/ is created
    And a configuration file bp_project/config.rb is created
    And a sass file bp_project/src/screen.sass is created
    And a sass file bp_project/src/print.sass is created
    And a sass file bp_project/src/ie.sass is created
    And a sass file bp_project/src/screen.sass is compiled
    And a sass file bp_project/src/print.sass is compiled
    And a sass file bp_project/src/ie.sass is compiled
    And a css file bp_project/stylesheets/screen.css is created
    And a css file bp_project/stylesheets/print.css is created
    And a css file bp_project/stylesheets/ie.css is created
    And an image file bp_project/images/grid.png is created
    And I am told how to link to /stylesheets/screen.css for media "screen, projection"
    And I am told how to link to /stylesheets/print.css for media "print"
    And I am told how to conditionally link "lt IE 8" to /stylesheets/ie.css for media "screen, projection"

  Scenario: Install a project with specific directories
    When I create a project using: compass create custom_project --using blueprint --sass-dir sass --css-dir css --images-dir assets/imgs
    Then a directory custom_project/ is created
    And a directory custom_project/sass/ is created
    And a directory custom_project/css/ is created
    And a directory custom_project/assets/imgs/ is created
    And a sass file custom_project/sass/screen.sass is created
    And a css file custom_project/css/screen.css is created
    And an image file custom_project/assets/imgs/grid.png is created

  Scenario: Perform a dry run of creating a project
    When I create a project using: compass create my_project --dry-run
    Then a directory my_project/ is not created
    But a configuration file my_project/config.rb is reported created
    And a sass file my_project/src/screen.sass is reported created
    And a sass file my_project/src/print.sass is reported created
    And a sass file my_project/src/ie.sass is reported created
    And I am told how to link to /stylesheets/screen.css for media "screen, projection"
    And I am told how to link to /stylesheets/print.css for media "print"
    And I am told how to conditionally link "IE" to /stylesheets/ie.css for media "screen, projection"

  Scenario: Creating a bare project
    When I create a project using: compass create bare_project --bare
    Then a directory bare_project/ is created
    And a configuration file bare_project/config.rb is created
    And a directory bare_project/src/ is created
    And a directory bare_project/stylesheets/ is not created
    And I am congratulated
    And I am told that I can place stylesheets in the src subdirectory
    And I am told how to compile my sass stylesheets

  Scenario: Creating a bare project with a framework
    When I create a project using: compass create bare_project --using blueprint --bare
    Then an error message is printed out: A bare project cannot be created when a framework is specified.
    And the command exits with a non-zero error code

  Scenario: Compiling an existing project.
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass compile
    Then a directory tmp/ is created
    And a sass file sass/layout.sass is reported compiled
    And a sass file sass/print.sass is reported compiled
    And a sass file sass/reset.sass is reported compiled
    And a sass file sass/utilities.sass is reported compiled
    And a css file tmp/layout.css is created
    And a css file tmp/print.css is created
    And a css file tmp/reset.css is created
    And a css file tmp/utilities.css is created

  Scenario: Compiling an existing project with a specified project
    Given I am using the existing project in test/fixtures/stylesheets/compass
    And I am in the parent directory
    When I run: compass compile tmp_compass
    Then a directory tmp_compass/tmp/ is created
    And a sass file tmp_compass/sass/layout.sass is reported compiled
    And a sass file tmp_compass/sass/print.sass is reported compiled
    And a sass file tmp_compass/sass/reset.sass is reported compiled
    And a sass file tmp_compass/sass/utilities.sass is reported compiled
    And a css file tmp_compass/tmp/layout.css is created
    And a css file tmp_compass/tmp/print.css is created
    And a css file tmp_compass/tmp/reset.css is created
    And a css file tmp_compass/tmp/utilities.css is created

  Scenario: Recompiling a project with no changes
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass compile
    And I run: compass compile
    Then a sass file sass/layout.sass is reported unchanged
    And a sass file sass/print.sass is reported unchanged
    And a sass file sass/reset.sass is reported unchanged
    And a sass file sass/utilities.sass is reported unchanged

  Scenario: Basic help
    When I run: compass help
    Then I should be shown a list of available commands
    And the list of commands should describe the compile command
    And the list of commands should describe the create command
    And the list of commands should describe the grid-img command
    And the list of commands should describe the help command
    And the list of commands should describe the init command
    And the list of commands should describe the install command
    And the list of commands should describe the version command

  Scenario: Recompiling a project with no material changes
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass compile
    And I wait 1 second
    And I touch sass/layout.sass
    And I run: compass compile
    Then a sass file sass/layout.sass is reported compiled
    Then a css file tmp/layout.css is reported identical
    And a sass file sass/print.sass is reported unchanged
    And a sass file sass/reset.sass is reported unchanged
    And a sass file sass/utilities.sass is reported unchanged