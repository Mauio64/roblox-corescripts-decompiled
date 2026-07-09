local _script = script
local _scriptParent = _script.Parent
local Cryo = require(_scriptParent.Cryo)
local RoduxNetworking = require(_scriptParent.RoduxNetworking)
local ContentSharingNetworking = require(_scriptParent.ContentSharingNetworking)
local ContentSharingReducer = require(_script.Reducers.ContentSharingReducer)

return {
	["jest.config"] = script["jest.config"],
	config = function(p1) -- line: 11
		-- upvalues: Cryo (copy), ContentSharingNetworking (copy), RoduxNetworking (copy), ContentSharingReducer (copy)
		local u8 = Cryo.Dictionary.join(p1, {
			ContentSharingNetworking = ContentSharingNetworking.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function() -- line: 19
				-- upvalues: ContentSharingReducer (copy), u8 (ref)
				return ContentSharingReducer(u8)
			end
		}
	end
}
