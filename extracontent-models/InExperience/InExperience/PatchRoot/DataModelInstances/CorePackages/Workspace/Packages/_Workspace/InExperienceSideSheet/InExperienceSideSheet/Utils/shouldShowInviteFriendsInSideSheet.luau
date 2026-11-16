return function(p: string, flag: boolean, flag2: boolean): boolean
	return p ~= "invite_friends" or not (flag and flag2)
end
