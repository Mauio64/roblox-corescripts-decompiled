local SocialContextToasts = script:FindFirstAncestor("SocialContextToasts")
local SocialContextToastsParent = SocialContextToasts.Parent
local Rodux = require(SocialContextToastsParent.Rodux)

require(SocialContextToasts.ToastRoot)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 7
	return {
		toastContent = p1
	}
end)
