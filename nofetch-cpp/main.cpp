#include <algorithm>
#include <fstream>
#include <functional>
#include <future>
#include <iostream>
#include <memory>
#include <random>
#include <string>
#include <vector>

// Define a class for storing the strings
class CustomString {
public:
  const std::string &getString() const { return string_; }
  void setString(const std::string &str) { string_ = str; }

private:
  std::string string_;
};

// Function to get a random string from an array (async)
std::shared_ptr<CustomString> getRandomStringAsync(int size) {
  // Create a random number generator
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_int_distribution<> distrib(0, size - 1);

  // Get a random index into the array
  int idx = distrib(gen);
  // Initialize the strings with some values
  const std::string strValues[] = {
      "probably a computer",
      "there's probably some ram in there",
      "init should ideally be running",
      "yeah",
      "you should probably go outside",
      "i would be lead to believe that / is mounted",
      "hey, what's this knob do?",
      "i use arch btw"};

  // Create a new CustomString object and return it
  auto result = std::make_shared<CustomString>();
  result->setString(strValues[idx]);
  return result;
}

// Function to read the contents of /proc/version (async)
std::future<std::string> readVersionAsync() {
  return std::async(std::launch::async, [&] {
    // Read the contents of /proc/version
    std::ifstream file("/proc/version");
    std::string rvers;
    if (file.is_open()) {
      std::getline(file, rvers);
      file.close();
    } else {
      throw std::runtime_error("Unable to read /proc/version");
    }
    return rvers;
  });
}

int main() {
  // Define an array size
  int size = 8;

  // Get a random string from the array asynchronously
  auto getAsync = getRandomStringAsync(size);

  // Read the contents of /proc/version asynchronously
  auto readVersionAsync_ = readVersionAsync();

  // Wait for the asynchronous operations to complete and print their results
  try {
    std::string result;
    result = getAsync->getString();
    std::string rvers = readVersionAsync_.get();

    // Find first '(' in the version string
    size_t idx = rvers.find('(');
    if (idx == std::string::npos) {
      idx = rvers.length();
    }

    // Extract the version string
    std::string version = rvers.substr(0, idx);

    // Trim white-space from the version string
    version.erase(version.find_last_not_of(" \t\n\r") + 1);

    // Print the output
    std::cout << "\n> " << result << "\n> " << version << "\n\n";

  } catch (const std::exception &e) {
    // This should never error but complexity go brr
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }

  return 0;
}
