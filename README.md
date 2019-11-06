# Amplitude Extension for Defold

This extension wraps Amplitude SDK for iOS (4.8.2). On other platforms this extension provides stub functions.

# API reference

## amplitude.init(params)

Call this function before invoking any other functions.

### `params` reference

- `api_key`, string, required. API key.

### Syntax

```language-lua
amplitude.init{
	api_key = 'YOUR KEY HERE'
}
```
___
## amplitude.track_event(params)

Track an event via the SDK.

### `params` reference

- `name`, string, required. Event name.
- `event_properties`, table, optional. A key-value set of extra event properties. Keys and values must be strings.

### Syntax

```language-lua
amplitude.track_event{
	name = 'event_name',
	event_properties = {
		key1 = 'value1',
		key2 = 'value2'
	}
}
```
