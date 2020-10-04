template <- '
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
 {{#links}}
   <url>
      <loc>{{{loc}}}</loc>
      <lastmod>{{{lastmod}}}</lastmod>
      <changefreq>{{{changefreq}}}</changefreq>
      <priority>{{{priority}}}</priority>
   </url>
 {{/links}}
</urlset>
'

list_files <- list.files(, '[.]html$')
for (i in list_files) {
  links <- print(c(paste0("https://devinjevian.github.io/", list_files)))
}
links[[length(links) + 1]] <- "https://devinjevian.github.io/"

map_links <- function(l) {
  tmp <- httr::GET(l)
  d <- tmp$headers[['last-modified']]
  
  list(loc = l,
       lastmod = format(as.Date(d,format = "%a, %d %b %Y %H:%M:%S")),
       changefreq = "monthly",
       priority = "0.8")
}

links <- lapply(links, map_links)
links[[length(links)]]$priority <- 1

cat(whisker::whisker.render(template), file = "sitemap.xml")