{module, test} = QUnit

module "<details>",
  beforeEach: ->
    fixtureHTML = """
      <div id="container">
        <details id="details">
          <summary id="summary">Summary</summary>
          <div id="content">Content</div>
        </details>
      </div>
    """
    document.body.insertAdjacentHTML("beforeend", fixtureHTML)

  afterEach: ->
    document.body.removeChild(document.getElementById("container"))


test "displays summary and hides content initially", (assert) ->
  done = assert.async()
  defer ->
    assert.notEqual getElement("summary").offsetHeight, 0
    assert.equal getElement("content").offsetHeight, 0
    done()

test "summary is focusable", (assert) ->
  done = assert.async()
  summary = getElement("summary")
  defer ->
    if (typeof HTMLDetailsElement is "undefined")
      assert.ok summary.hasAttribute("tabindex")
      assert.ok summary.hasAttribute("role")
    summary.focus()
    assert.equal document.activeElement, summary
    done()

test "open property toggles content", (assert) ->
  done = assert.async()

  element = getElement("details")
  content = getElement("content")

  toggleEventCount = 0
  element.addEventListener "toggle", -> toggleEventCount++
  defer ->
    element.open = true
    defer ->
      assert.notEqual content.offsetHeight, 0
      assert.ok element.hasAttribute("open")
      assert.ok element.open
      assert.equal toggleEventCount, 1

      element.open = false
      defer ->
        assert.equal content.offsetHeight, 0
        assert.notOk element.hasAttribute("open")
        assert.notOk element.open
        defer ->
          assert.equal toggleEventCount, 2
          done()

test "open attribute toggles content", (assert) ->
  done = assert.async()

  element = getElement("details")
  content = getElement("content")

  toggleEventCount = 0
  element.addEventListener "toggle", -> toggleEventCount++

  defer ->
    element.setAttribute("open", "")
    defer ->
      assert.notEqual content.offsetHeight, 0
      assert.equal toggleEventCount, 1

      element.removeAttribute("open")
      defer ->
        assert.equal content.offsetHeight, 0
        assert.equal toggleEventCount, 2
        done()

test "click <summary> toggles content", (assert) ->
  done = assert.async()

  element = getElement("details")
  summary = getElement("summary")
  content = getElement("content")

  toggleEventCount = 0
  element.addEventListener "toggle", -> toggleEventCount++

  defer ->
    clickElement summary, ->
      assert.notEqual content.offsetHeight, 0
      assert.ok element.hasAttribute("open")
      assert.equal toggleEventCount, 1

      clickElement summary, ->
        assert.equal content.offsetHeight, 0
        assert.notOk element.hasAttribute("open")
        assert.ok toggleEventCount, 2
        done()

test "click <summary> child toggles content", (assert) ->
  done = assert.async()

  element = getElement("details")
  summary = getElement("summary")
  content = getElement("content")

  summaryChild = document.createElement("span")
  summary.appendChild(summaryChild)

  toggleEventCount = 0
  element.addEventListener "toggle", -> toggleEventCount++

  defer ->
    clickElement summaryChild, ->
      assert.notEqual content.offsetHeight, 0
      assert.ok element.hasAttribute("open")
      assert.equal toggleEventCount, 1

      clickElement summaryChild, ->
        assert.equal content.offsetHeight, 0
        assert.notOk element.hasAttribute("open")
        assert.ok toggleEventCount, 2
        done()

getElement = (id) ->
  document.getElementById(id)

defer = (callback) ->
  setTimeout(callback, 30)

clickElement = (element, callback) ->
  try
    event = new MouseEvent("click", view: window, bubbles: true, cancelable: true)
  catch
    event = document.createEvent("MouseEvents")
    event.initEvent("click", true, true)

  element.dispatchEvent(event)
  defer(callback)
