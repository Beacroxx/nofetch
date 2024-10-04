use rand::seq::SliceRandom;
use std::fs;

fn main() {
  // Construct the path to the configuration file.
  let mut cfgpath = home::home_dir().expect("Unable to get home directory.");
  cfgpath.push(".config/nofetch-rs/config.toml");

  // Read the configuration file.
  let config = match fs::read_to_string(&cfgpath) {
    Ok(c) => c,
    Err(e) => {
      eprintln!(
        "Unable to read {0}: {1}\nHave you created it?",
        cfgpath.to_string_lossy(),
        e
      );
      return;
    }
  };

  // Parse the configuration file.
  let config: toml::Value = match toml::from_str(&config) {
    Ok(c) => c,
    Err(e) => {
      eprintln!("Unable to parse {0}: {1}", cfgpath.to_string_lossy(), e);
      return;
    }
  };

  // Extract the "strings" array from the configuration.
  let strings = match config.get("strings").and_then(toml::Value::as_array) {
    Some(s) if !s.is_empty() => s,
    _ => {
      eprintln!("Error: config.toml must contain a 'strings' array with at least one string.");
      return;
    }
  };

  // Select a random string from the array.
  let mut rng = rand::thread_rng();
  let rstring = strings
    .choose(&mut rng)
    .unwrap()
    .as_str()
    .expect("strings array should contain only strings");

  // Read the OS version from /proc/version.
  let rvers = match fs::read_to_string("/proc/version") {
    Ok(v) => v,
    Err(e) => {
      eprintln!("Unable to read /proc/version: {}", e);
      return;
    }
  };

  // Extract the version string.
  let idx = rvers.find('(').unwrap_or(rvers.len());
  let version = &rvers[..idx].trim();

  // Print the output.
  println!("\n> {0}\n> {1}\n", rstring, version);
}
