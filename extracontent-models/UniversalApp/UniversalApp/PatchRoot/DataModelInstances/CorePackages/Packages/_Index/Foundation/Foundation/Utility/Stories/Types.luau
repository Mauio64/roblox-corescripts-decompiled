local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Enums.Device)
require(Foundation.Providers.Preferences.PreferencesProvider)
require(Foundation.Enums.Theme)

return {
	toDeveloperStorybookStoryProps = function(p1) -- line: 22
		if rawget(p1, "focus") then
			return p1
		end

		return nil
	end,
	toFlipbookStoryProps = function(p2) -- line: 38
		if rawget(p2, "widget") then
			return p2
		end

		return nil
	end
}
