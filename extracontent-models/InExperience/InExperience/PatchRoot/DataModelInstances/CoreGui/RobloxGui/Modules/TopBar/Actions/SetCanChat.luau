local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local FFlagTopBarDeprecateChatRodux = require(ParentParent.Flags.FFlagTopBarDeprecateChatRodux)
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator

if FFlagTopBarDeprecateChatRodux then
	return nil
end

return (makeActionCreator(script.Name, function(p1) -- line: 11
	return {
		canChat = p1
	}
end))
