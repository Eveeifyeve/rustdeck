use std::path::PathBuf;
use url::Url;

pub struct Plugins {}

impl Plugins {
    pub fn new_instance() {}
    pub fn add() {}
    pub fn remove() {}
}

pub enum Source {
    Local(PathBuf),
    Remote(Url),
}

impl Source {
    pub fn new_local(path: PathBuf) -> Source {
        Source::Local(path)
    }

    pub fn new_remote(url: Url) -> Source {
        Source::Remote(url)
    }
}
