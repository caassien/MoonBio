pub fn parse_fasta(content: String) -> Array[FastaRecord] {
  let records = []
  let mut current_id = ""
  let mut current_seq = ""
  
  let len = content.length()
  let mut i = 0
  
  while i < len {
    let mut line = ""
    while i < len && content[i] != '\n' {
      if content[i] != '\r' {
        line = line + content[i].to_string()
      }
      i = i + 1
    }
    i = i + 1 // skip newline
    
    if line.length() > 0 {
      if line[0] == '>' {
        if current_id != "" {
          records.push({ id: current_id, sequence: current_seq })
        }
        let mut id = ""
        for j = 1; j < line.length(); j = j + 1 {
          id = id + line[j].to_string()
        }
        current_id = id
        current_seq = ""
      } else {
        current_seq = current_seq + line
      }
    }
  }
  
  if current_id != "" {
    records.push({ id: current_id, sequence: current_seq })
  }
  
  records
}
