deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}

deployit_dictionary { "Environments/dict1":
  server   => Deployit["remote"],
  entries => {
  "A" => "1",
  "B" => "3"
  },
  ensure   => absent,


}





