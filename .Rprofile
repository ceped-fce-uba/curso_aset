local({
  if (nzchar(Sys.getenv("RSTUDIO_PANDOC"))) {
    return(invisible(NULL))
  }

  pandoc_candidates <- c(
    "C:/Users/facun/AppData/Local/Microsoft/WinGet/Packages/JohnMacFarlane.Pandoc_Microsoft.Winget.Source_8wekyb3d8bbwe/pandoc-3.9.0.2/pandoc.exe",
    "C:/Program Files/Quarto/bin/tools/pandoc/pandoc.exe",
    "C:/Program Files/RStudio/bin/pandoc/pandoc.exe",
    "C:/Program Files/Pandoc/pandoc.exe"
  )

  pandoc_path <- pandoc_candidates[file.exists(pandoc_candidates)][1]

  if (!is.na(pandoc_path) && nzchar(pandoc_path)) {
    Sys.setenv(RSTUDIO_PANDOC = dirname(pandoc_path))
  }

  invisible(NULL)
})
