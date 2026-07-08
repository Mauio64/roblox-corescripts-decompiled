local Icon = require(script.Icon)
local IconVariant = require(script.IconVariant)
local Font = require(script.Font)
local Migration = require(script.Migration)
local builderIconPlatformUtils = require(script.builderIconPlatformUtils)
local getBuilderIconForKeycode = builderIconPlatformUtils.getBuilderIconForKeycode
local getBuilderIconForCurrentPlatform = builderIconPlatformUtils.getBuilderIconForCurrentPlatform

return {
	Icon = Icon,
	IconVariant = IconVariant,
	Font = Font,
	Migration = Migration,
	getBuilderIconForKeycode = getBuilderIconForKeycode,
	getBuilderIconForCurrentPlatform = getBuilderIconForCurrentPlatform
}
