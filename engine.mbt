pub struct BioEngine {
  _version: Int
} derive(Debug, Eq)

pub fn BioEngine::new() -> BioEngine {
  { _version: 1 }
}
