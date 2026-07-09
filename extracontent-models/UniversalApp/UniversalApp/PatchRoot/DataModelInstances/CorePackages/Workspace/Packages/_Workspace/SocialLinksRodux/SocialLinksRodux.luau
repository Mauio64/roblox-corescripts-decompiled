local _script = script
local _scriptParent = _script.Parent
local Cryo = require(_scriptParent.Cryo)
local RoduxNetworking = require(_scriptParent.RoduxNetworking)
local SocialLinksNetworking = require(_scriptParent.SocialLinksNetworking)
local SocialLinksReducer = require(_script.Reducers.SocialLinksReducer)

return {
	["jest.config"] = script["jest.config"],
	config = function(p1) -- line: 11
		-- upvalues: Cryo (copy), SocialLinksNetworking (copy), RoduxNetworking (copy), SocialLinksReducer (copy)
		local u8 = Cryo.Dictionary.join(p1, {
			SocialLinksNetworking = SocialLinksNetworking.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function() -- line: 19
				-- upvalues: SocialLinksReducer (copy), u8 (ref)
				return SocialLinksReducer(u8)
			end
		}
	end
}
