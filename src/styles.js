export default `
details, summary {
  display: block;
}
details:not([open]) > *:not(summary) {
  display: none;
}
details > summary::before {
  content: "►";
  padding-right: 0.3rem;
  font-size: 0.6rem;
  cursor: default;
}
details[open] > summary::before {
  content: "▼";
}
`
