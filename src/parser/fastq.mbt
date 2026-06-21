pub struct FastqRecord {
  id: String
  sequence: String
  quality: String
}

pub fn parse_fastq(content: String) -> Array[FastqRecord] {
  let records = []
  let lines = []
  let mut current_line = ""
  
  for i = 0; i < content.length(); i = i + 1 {
    let c = content[i]
    if c == '\n' {
      if current_line.length() > 0 && current_line[current_line.length() - 1] == '\r' {
        let end = current_line.length() - 1
        current_line = current_line[:end].to_owned()
      }
      lines.push(current_line)
      current_line = ""
    } else {
      current_line = current_line + c.to_string()
    }
  }
  if current_line.length() > 0 {
    lines.push(current_line)
  }

  let mut i = 0
  while i + 3 < lines.length() {
    let id_line = lines[i]
    let seq_line = lines[i + 1]
    // let plus_line = lines[i + 2]
    let qual_line = lines[i + 3]
    
    let id = if id_line.length() > 0 && id_line[0] == '@' {
      id_line[1:].to_owned()
    } else {
      id_line
    }
    
    records.push({ id, sequence: seq_line, quality: qual_line })
    i = i + 4
  }
  
  records
}
