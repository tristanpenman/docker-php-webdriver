<?php

namespace Facebook\WebDriver;

use Facebook\WebDriver\Remote\RemoteWebDriver;
use Facebook\WebDriver\Remote\WebDriverBrowserType;
use Facebook\WebDriver\Remote\WebDriverCapabilityType;

require_once('/wd/vendor/autoload.php');

class GoogleTest extends \PHPUnit_Framework_TestCase {

	/** @var $driver RemoteWebDriver */
	protected $driver;

	protected $browser;

	protected function setUp() {
		$this->browser = getenv('BROWSER') ? getenv('BROWSER') : 'firefox';
		$this->driver = RemoteWebDriver::create( 'http://hub:4444/wd/hub', array(
			WebDriverCapabilityType::BROWSER_NAME => $this->browser
		) );
	}

	protected function tearDown() {
		$this->driver->close();
	}

	public function testGoogle() {
		$this->driver->get( 'http://www.google.com' );
		self::assertEquals( 'Google', $this->driver->getTitle() );
	}
}
