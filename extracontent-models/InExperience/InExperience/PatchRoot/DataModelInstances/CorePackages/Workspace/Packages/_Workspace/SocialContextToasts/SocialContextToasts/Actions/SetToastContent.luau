local SocialContextToasts = script:FindFirstAncestor("SocialContextToasts")
local parent = SocialContextToasts.Parent
local Rodux = require(parent.Rodux)
require(SocialContextToasts.ToastRoot)

return Rodux.makeActionCreator(script.Name, function(toastContent)
	return { toastContent = toastContent }
end)
