<?php

/**
 * Adminer plugin that provides links to docker containers.
 */
class AdminerDockerLinks {
	public static $CONTAINER_FILE = '';

	function navigation($missing) {
		if ($missing != 'auth') return;

		// Load the containers list
		$connections = null;
		if (file_exists(self::$CONTAINER_FILE)) {
			$connections = json_decode(file_get_contents(self::$CONTAINER_FILE));
		}

		// Display login links for each of these
		echo "<h1>Docker links</h1>";
		echo "<p id='docker-links'>";
		if ($connections == null) {
			echo "Containers file does not exist. Please check the logs of the adminer-gen container?<br />";
		} else if (empty($connections)) {
			echo "No containers found. Don't forget to expose the correct environment variable(s)<br />";
		} else {
			foreach ($connections as $connection) {
				$connection = (array) $connection;

				// Store the password for the server, so that auto-login can work
				set_password(
					$connection['engine'],
					$connection['host'],
					$connection['username'],
					$connection['password']
				);

				// Display a link to the auto-login for this connection
				$url = h(auth_url(
					$connection['engine'],
					$connection['host'],
					$connection['username'],
					$connection['db']
				));
				echo "<a href='$url'>{$connection['name']}</a><br />";
			}
		}
		echo "</p>";
	}
}
AdminerDockerLinks::$CONTAINER_FILE = dirname(realpath(__FILE__)) . '/containers.json';
