///|
fn print_result(prefix : String, result : Result[String, String]) -> Unit {
  match result {
    Ok(message) => println(prefix + message)
    Err(message) => println(prefix + "error: " + message)
  }
}

///|
fn main {
  let engine = @moonbio.BioEngine::new()
  println("MoonBio CLI demo")

  let global = engine.global_align("GATTACA", "GCATGCU")
  println("Global alignment score: \{global.score}")
  println("Seq1: \{global.alignment_a}")
  println("Seq2: \{global.alignment_b}")

  let msa = engine.multiple_align(["GATTACA", "GCATGCU", "GACTACA"])
  println("MSA consensus: \{msa.consensus}")
  for i = 0; i < msa.aligned_sequences.length(); i = i + 1 {
    println("MSA[\{i}]: \{msa.aligned_sequences[i]}")
  }

  let fasta_demo = ">seq1\nGATTACA\n>seq2\nGACTATA\n"
  let fastq_demo = "@read1\nGATTACA\n+\nIIIIIII\n@read2\nGACTATA\n+\nHHHHHHH\n"
  print_result("FASTA summary: ", engine.summarize_fasta(fasta_demo))
  print_result("FASTQ summary: ", engine.summarize_fastq(fastq_demo))
}
