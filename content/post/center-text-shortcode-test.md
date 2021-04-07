---
title: Test of center-text shortcode
draft: true
date: 2021-03-14
lastmod: 2021-04-04
---

# Test of center-text shortcode

Change draft to false in front-matter and run this with both configs below.  **Don't forget** to change draft back to true after the test.

```
markup:
  goldmark:
    renderer:
      unsafe: true
```

and

```
markup:
  goldmark:
    renderer:
      unsafe: false
```

**Percent tests:**

{{% center-text %}}
*percent foo*
{{% /center-text %}}

{{% center-text %}}
*<p>percent bar p before foo</p>*
*percent foo after bar*
{{% /center-text %}}

{{% center-text %}}
<p>percent bar p before foo no stars</p>
*percent foo after bar*
{{% /center-text %}}

{{% center-text %}}
*<p>percent bar p</p>*
{{% /center-text %}}

**Angle tests:**

{{< center-text >}}
*angle foo*
{{< /center-text >}}

{{< center-text >}}
*<p>angle bar p before foo</p>*
*angle foo after bar*
{{< /center-text >}}

{{< center-text >}}
<p>angle bar p before foo no stars</p>
*angle foo after bar*
{{< /center-text >}}

{{< center-text >}}
*<p>angle bar p</p>*
{{< /center-text >}}

