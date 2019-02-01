doi1 <- "10.1108/jd-12-2013-0166"
doi2 <- "10.6084/m9.figshare.3443876"
oci1 <-
  "02001010806360107050663080702026306630509-0200101080636102704000806"

context("oc_coci_refs")
test_that("oc_coci_refs works", {
  vcr::use_cassette("oc_coci_refs", {
    x <- oc_coci_refs(doi1)
  })

  expect_is(x, "data.frame")
  expect_is(x, "tbl_df")
  expect_is(x, "tbl")
  expect_is(x$cited, "character")
  expect_is(x$oci, "character")
  expect_is(x$citing, "character")

  # all DOIs
  expect_match(x$cited, "10\\.")
  expect_match(x$citing, "10\\.")
  
  # all citing equal DOI passed in
  expect_equal(length(unique(x$citing)), 1)
  # all cited are other DOIs
  expect_false(any(grepl(doi1, x$cited)))
})
test_that("oc_coci_refs fails well", {
  expect_error(oc_coci_refs(), "argument \"doi\" is missing")
  expect_error(oc_coci_refs(5), "doi must be of class")
})



context("oc_coci_cites")
test_that("oc_coci_cites works", {
  vcr::use_cassette("oc_coci_cites", {
    x <- oc_coci_cites(doi1)
  })

  expect_is(x, "data.frame")
  expect_is(x, "tbl_df")
  expect_is(x, "tbl")
  expect_is(x$cited, "character")
  expect_is(x$oci, "character")
  
  # all DOIs
  expect_match(x$cited, "10\\.")
  expect_match(x$citing, "10\\.")
  
  # all cited are other DOIs
  expect_equal(length(unique(x$cited)), 1)
  # all citing equal DOI passed in
  expect_false(any(grepl(doi1, x$citing)))
})
test_that("oc_coci_cites fails well", {
  expect_error(oc_coci_cites(), "argument \"doi\" is missing")
  expect_error(oc_coci_cites(5), "doi must be of class")
})



context("oc_coci_meta")
test_that("oc_coci_meta works", {
  vcr::use_cassette("oc_coci_meta", {
    x <- oc_coci_meta(doi1)
  })

  expect_is(x, "data.frame")
  expect_is(x, "tbl_df")
  expect_is(x, "tbl")
  expect_is(x$citation, "character")
  expect_is(x$author, "character")
  expect_is(x$reference, "character")
  
  # all DOIs
  expect_match(x$citation, "10\\.")
  expect_match(x$reference, "10\\.")

  # matches passed in DOI
  expect_match(x$doi, doi1)
})
test_that("oc_coci_meta fails well", {
  expect_error(oc_coci_meta(), "argument \"doi\" is missing")
  expect_error(oc_coci_meta(5), "doi must be of class")
})



context("oc_coci_citation")
test_that("oc_coci_citation works", {
  vcr::use_cassette("oc_coci_citation", {
    x <- oc_coci_citation(oci1)
  })

  expect_is(x, "data.frame")
  expect_is(x, "tbl_df")
  expect_is(x, "tbl")
  expect_is(x$cited, "character")
  expect_is(x$oci, "character")
  expect_is(x$citing, "character")

  expect_equal(NROW(x), 1)
  
  # all DOIs
  expect_match(x$cited, "10\\.")
  expect_match(x$citing, "10\\.")
  
  # all cited are other DOIs
  expect_equal(length(unique(x$cited)), 1)
  
  # citing equals OCI passed in
  expect_match(oci1, x$oci)
})
test_that("oc_coci_citation fails well", {
  expect_error(oc_coci_citation(), "argument \"oci\" is missing")
  expect_error(oc_coci_citation(5), "oci must be of class")
})