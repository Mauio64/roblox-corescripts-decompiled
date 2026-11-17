local RunService = game:GetService("RunService")

return {
	once = function(onPreRender)
		return RunService.PreRender:Once(onPreRender)
	end
}
