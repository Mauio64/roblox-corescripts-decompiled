local Plugin = script:FindFirstAncestorWhichIsA("Plugin")

return {
	context = not Plugin and "unknown" or "plugin",
	plugin_name = if not Plugin then nil else Plugin.Name
}
