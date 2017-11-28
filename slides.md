---
title: Snapshot Testing APIs
theme: moon
css: style.css
revealOptions:
    transition: 'fade'
---

<img src="snapshot-testing-apis.jpg" class="plain"/>

Dave Ceddia

*@dceddia*

Note:

Hey I'm Dave Ceddia, and I want to tell you about a simple way you can improve your development process with snapshot testing.

So let me set the stage here...

---

`$ git pull`

Note:
Do a build, start everything up... **NEXT**

---

<img src="signin-form.png" class="plain"/>

Note:
And when you go to log in, you type the password wrong.

But instead of... **NEXT**

---

<img src="signin-form-error.png" class="plain"/>

Note:
the normal error message...

---

<img src="exception.png" />

Note:
You get this one instead.

Because for some reason the response from the server wasn't what you expected.

Well it doesn't seem like it's your code's fault,
so take a walk over to the backend team...

---

<img src="keep-calm.png" class="plain keep-calm"/>

Note:

Hey guys, so, what happened to the error response on login? It's not an object anymore?

And they go:

"Yeah! We changed it. We return an array now, because you never know when we might need to support more than one error."

---

<img src="unamused.png" class="plain"/>


Note:

"We TOLD you about it in standup"

And there was a slack message

And your boss chimes in like:

yeah didn't you see that?

---

<img src="lumbergh.jpg" class="lumbergh"/>

Note:
So now you're wondering who's really to blame here, and starting to think it might be you.

---

<img src="keep-calm-ui.png" class="plain keep-calm"/>

---

<img src="thinking-face.png" class="plain"/>

Note:

But wouldn't it be nice if you had some tests that could catch this kind of failure?

Before it ripped your team apart?

---

## End-to-end testing?

<ul>
  <li class="fragment">Slow to write</li>
  <li class="fragment">Slow to run</li>
  <li class="fragment">Brittle</li>
</ul>

Note:

E2E testing might be your first thought.

This is where you'd write tests with a tool like Selenium or Nightwatch, and run them in a real browser against a running copy of your app. But it has some downsides.

**DO BULLETS**

---

## Snapshot Testing!

No more broken APIs.

Note:
Show of hands:
- Who's heard of snapshot testing?
- Who's already using it?

Cool, so here's a quick overview if you're not familiar.

---

## 1. A React Component

<img src="list-component.png" class="plain" width="50%"/>

Note:

The idea is that if you have a React component like this...

---

## 2. A Test

<img src="list-test.png" class="plain" width="50%" />

Note:

You can write a really simple test that renders the component in memory and checks it against a snapshot.

---

## 3. Writes a Snapshot

<img src="list-snapshot.png" class="plain" width="50%" />

Note:

The first time you run it, there's no saved snapshot, so the test will pass. So you want to make sure that the component is correct before you run the test!

---

## 4. Next run: Check the Snapshot

Note:

Then every time after that, when you run the test, it will compare the rendered snapshot with the one on disk, and fail the test if they don't match.

This gives you a quick way to make sure if something works ONCE, it KEEPS WORKING, and alerts you if it breaks.

---

## Aside:

expect(...).toMatchSnapshot()

-----------

1. `npm install enzyme-to-json`

2. Add to package.json:

```json
"jest": {
	"snapshotSerializers": ["enzyme-to-json/serializer"]
}
```

---

but...

## did you know?

Note:

But: fun fact! You can take snapshots of anything!

---

`expect(`

  *`any_type_you_want`*

`).toMatchSnapshot()`

---

<img src="snapshot-all-the-things.png" class="plain all-the-things"/>

Note:

you can basically snapshot anything

including API responses

---

## 3 Steps To Success
<ol>
  <li class="fragment">Make an API call.</li>
  <li class="fragment">Snapshot the result.</li>
  <li class="fragment">Rest easy.</li>
</ol>


---

## This is for real

* Real API calls
* Not mocked
* Requires a running server
* **Clean the data** between tests!

Note:

Here's an example of one of these tests

---

<img src="example-test-2.png" class="plain"/>

<!--
test('good login', async () => {
	const response = await API.login(
		'test-account@example.com',
		'supersecret!'
	);
	expect(response.data).toMatchSnapshot();
});
-->

Note:

* it makes a call to the login API
* then it expects that the response matches the snapshot
* using async/await
* the `await` just pauses on that line until the promise resolves
* the `async` marks the function as asynchronous, so it can contain `await`.

---

<img src="snapshot-login-success.png" class="plain"/>

---

<img src="example-test-1.png" class="plain"/>

<!--
test('failed login (bad password)', async () => {
  let data;
  try {
    data = await API.login('me@example.com', 'wrong_password');
    fail();
  } catch(e) {
    expect(e.response.data).toMatchSnapshot();
  }
});
-->

---

<img src="snapshot-login-error.png" class="plain"/>

---

<img src="snapshot-login-success.png" class="plain"/>

---

## Some Things Change

<img src="bleach.jpg" class="fragment plain bleach"/>

Sanitize them.

<ul>
  <li class="fragment">Randomized IDs</li>
  <li class="fragment">Timestamps</li>
</ul>

Note:
some things change! don't let them break your tests.

Sanitize things like randomized IDs, Timestamps,
anything that might change between responses.

---

<img src="example-test-3.png" class="plain"/>

<!--
test('createOrder', async () => {
	let order = await API.createOrder('Camera', 19.84);
	order = sanitize(order, ['id', 'created_at']);
	expect(order).toMatchSnapshot();
});
-->


Note:
here's an example of testing something that changes

we make an API call to buy a camera for an ominous price

then pass the result through the *sanitize* function,
giving it an array of keys to sanitize

---

<img src="snapshot-create-order.png" class="plain" width="50%" />

---

<img src="sanitize.png" class="plain"/>

<!--
import * as _ from 'lodash';
import * as API from 'api';

function sanitize(data, keys) {
  return keys.reduce((result, key) => {
    const val = _.get(result, key);
    if(!val || _.isArray(val) || _.isObject(val)) {
      return result;
    } else {
      return _.set(_.cloneDeep(result), key, '[SANITIZED]');
    }
  }, data);
}
-->

---

## Dave Ceddia

@dceddia

[daveceddia.com](https://daveceddia.com)

<div style="line-height:0;">
	<img src="pure-react-3d-cover.svg" class="plain book"/>
	<br/>
	<a href="purereact.com" class="pure-react-link">purereact.com</a>
</div>

<!-- <img src="https://daveceddia.com/images/pure-react-3d-cover.svg" alt="book cover" height="200" style="border: none;"/> -->

Note: dceddia on the interwebz. Blog about React

