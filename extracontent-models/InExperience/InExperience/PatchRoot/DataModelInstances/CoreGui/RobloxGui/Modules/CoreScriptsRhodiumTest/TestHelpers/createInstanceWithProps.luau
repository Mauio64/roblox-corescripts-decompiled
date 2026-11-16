local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

return function(p, p2, size)
	local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
	local myElement

	if size then
		myElement = Roact.createElement("Frame", { Size = size }, {
			testElement = Roact.createElement(p, p2)
		})
	else
		myElement = Roact.createElement(p, p2)
	end

	local fragment = Roact.createFragment({
		styleProvider = Roact.createElement(UIBlox.App.Style.AppStyleProvider, {
			style = { themeName = "Dark", fontName = "Gotham" }
		}, { myElement = myElement })
	})

	local v = Roact.mount(fragment, screenGui)

	return screenGui, function()
		Roact.unmount(v)
		screenGui:Destroy()
	end
end
