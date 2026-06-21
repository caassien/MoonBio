fn main {
  println("MoonBio CLI Engine v0.1.0 started.")
  let res = @align.needleman_wunsch("GATTACA", "GCATGCU", 1, -1, -1)
  println("Alignment Score: \{res.score}")
  println("Seq 1: \{res.alignment_a}")
  println("Seq 2: \{res.alignment_b}")
}
