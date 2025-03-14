fn main() {
    // delete existing version file created by blink.download
    let _ = std::fs::remove_file("target/release/version");
}
