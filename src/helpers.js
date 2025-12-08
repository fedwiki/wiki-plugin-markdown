// from marked https://github.com/markedjs/marked/blob/master/src/helpers.ts

const other = {
  escapeTest: /[&<>"']/,
  escapeReplace: /[&<>"']/g,
  escapeTestNoEncode: /[<>"']|&(?!(#\d{1,7}|#[Xx][a-fA-F0-9]{1,6}|\w+);)/,
  escapeReplaceNoEncode: /[<>"']|&(?!(#\d{1,7}|#[Xx][a-fA-F0-9]{1,6}|\w+);)/g,
}

export function escape(html, encode) {
  if (encode) {
    if (other.escapeTest.test(html)) {
      return html.replace(other.escapeReplace, getEscapeReplacement)
    }
  } else {
    if (other.escapeTestNoEncode.test(html)) {
      return html.replace(other.escapeReplaceNoEncode, getEscapeReplacement)
    }
  }

  return html
}

export function cleanUrl(href) {
  try {
    href = encodeURI(href).replace(other.percentDecode, '%')
  } catch {
    return null
  }
  return href
}
