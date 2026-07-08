local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

require(CorePackages.Packages.UIBlox).init(require(CorePackages.Workspace.Packages.RobloxAppUIBloxConfig))

local StoryStore = require(script.Parent.Helpers.StoryStore)
local ChatSettings = require(script.Parent.ChatSettings)

Roact.setGlobalConfig({
	elementTracing = true,
	propValidation = true
})

return {
	roact = Roact,
	mapStory = function(p1) -- line: 19
		-- upvalues: Roact (copy), RoactRodux (copy), StoryStore (copy), Cryo (copy), ChatSettings (copy)
		return function(p2) -- line: 20
			-- upvalues: Roact (copy), RoactRodux (copy), StoryStore (copy), p1 (copy), Cryo (copy), ChatSettings (copy)
			return Roact.createElement(RoactRodux.StoreProvider, {
				store = StoryStore
			}, {
				Story = Roact.createElement(p1, Cryo.Dictionary.join(p2, {
					chatSettings = ChatSettings
				}))
			})
		end
	end
}
