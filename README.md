# Docker Image for php-webdriver #

## Overview ##

This repo contains an unofficial Docker image for Facebook's [php-webdriver library](https://github.com/facebook/php-webdriver), currently at version 1.1.

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

### Docker Compose ###

An example Compose file for Docker Compose has also been included. This file configures Docker containers for Selenium Hub, Chrome and Firefox nodes, and for running PHPUnit.

To run the example PHPUnit/php-webdriver tests, use the following command:

    docker-compose run --rm php-webdriver

Bu using Docker Compose's 'run' command with the `--rm` option, the container will be automatically deleted after it shuts down. However, the Selenium Grid will continue running in the background. You can verify this using `docker ps`:

    # Summarised 'docker ps' output from my development machine:

    CONTAINER ID    IMAGE                    ...    PORTS                    NAMES
    4278ccf89da9    selenium/node-chrome     ...                             dockerphpwebdriver_chrome_1
    7d864086c7a2    selenium/node-firefox    ...                             dockerphpwebdriver_firefox_1
    0eb85c56fac4    selenium/hub             ...    0.0.0.0:4444->4444/tcp   dockerphpwebdriver_hub_1

When you're finished using the Selenium Grid, you can remove these containers:

    docker-compose rm -f

## Customisation ##

This image has been designed with customisation in mind.

You may notice that this repo includes a script called `docker-entrypoint.sh`, which is run by the container at startup. This script will look for, and run, any executable files placed in the '/scripts/entrypoint.d' directory.

This can be useful for performing pre-testing tasks on the php-webdriver container, or waiting for external resources/containers to be available.

## License ##

This Docker image is licensed under the MIT License.

See the LICENSE file for more information.
