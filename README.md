# Objective-C Associated Object Request Context Demo

A runnable macOS command-line project that attaches diagnostic request context to an existing Objective-C class through associated objects. It verifies copy semantics and confirms that retained associated state is released with its owner.

## Requirements

- macOS
- Xcode Command Line Tools (`xcode-select --install`)

## Run

```bash
git clone https://github.com/2252408699/objc-associated-object-request-context-demo.git
cd objc-associated-object-request-context-demo
make run
```

Expected checks:

```text
Copy policy preserved label: PASS
Owner lifecycle released context: PASS
```

## What it demonstrates

- Category accessors backed by `objc_setAssociatedObject` and `objc_getAssociatedObject`.
- Stable, address-unique static keys.
- `COPY_NONATOMIC` for value-style text and `RETAIN_NONATOMIC` for owned context.
- Associated values are released when the owning object is destroyed.

Do not use associated objects as hidden global storage. Avoid retain cycles when an associated value refers back to its owner, and do not depend on private Runtime storage layouts as API contracts.
