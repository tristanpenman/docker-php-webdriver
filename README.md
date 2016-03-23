# Docker Image for PHP Webdriver #

## Overview ##

This repo contains an unofficial Docker image for Facebook's [PHP Webdriver library](https://github.com/facebook/php-webdriver), currently at version 1.1.

This image also includes [PHPUnit](https://github.com/sebastianbergmann/phpunit) version 5.2.

## Usage ##

You can pull the latest build from Docker Hub:

    docker pull tristanpenman/php-webdriver

### Start Selenium Grid ###

Start Selenium Grid with instances for Firefox and Chrome:

    docker run -d --name selenium-hub selenium/hub
    docker run -d --link selenium-hub:hub --name selenium-chrome selenium/node-chrome 
    docker run -d --link selenium-hub:hub --name selenium-firefox selenium/node-firefox

### Running Tests ###

This repo includes a simple test case that visits 'google.com' and asserts that the title contains the word 'Google'. This test case is written in PHP, using PHPUnit.

Running the test case is as simple as:

    docker run -it --rm --link selenium-hub:hub -v $PWD:/wd/src tristanpenman/php-webdriver

This will locate all tests in the current directory (recursive search) and run them against Firefox by default. You should see the usual PHPUnit output, confirming that one test was executed.

### Other Browsers ###

To run tests against Chrome, or other browsers available in your Selenium grid, you can set the `BROWSER` environment variable:

    docker run -it --rm --link selenium-hub:hub -v $PWD:/wd/src \
        -e BROWSER=chrome tristanpenman/php-webdriver

### Docker Options ###

It can be helpful to understand the purpose of the options on the Docker command line, so that you know what to change to make this image work for your use cases:

  * `--link selenium-hub:hub` makes the `selenium-hub` container available to other containers at the hostname 'hub'. This avoids the hassles associated with hard-coded IP addresses.

  * `-it` is actually `-i` (Keep STDIN open even if not attached) and `-t` (Allocate a pseudo-TTY). Together, these make the CLI work nicely in interactive mode.

  * `-v $PWD:/wd/src` mounts the current host directory at `/wd/src` in the container. This is where PHPUnit will look for tests by default.

  * `-d` runs a container in Daemon mode, and `--rm` causes Docker to automatically remove a container when it shuts down. Note that this option is not used with `-d` for the Selenium Grid containers, as they run in the background.

## License ##

This Docker image is licensed under the MIT License.

See the LICENSE file for more information.
