-- input library test harness

--[[
copyright 2020 jbq

licensed under the apache license, version 2.0 (the "license");
you may not use this file except in compliance with the license.
you may obtain a copy of the license at

    http://www.apache.org/licenses/license-2.0

unless required by applicable law or agreed to in writing, software
distributed under the license is distributed on an "as is" basis,
without warranties or conditions of any kind, either express or implied.
see the license for the specific language governing permissions and
limitations under the license.
]]

function _init()
	input:init()
	cls()
end

function _update()
	input:update()
end

function _draw()
	cls(0)
	local i
	for i=1,6 do
		local x=((i-1)*20)
		local c1,c2
		if (input:button(i)) then
			c1=7
		else
			c1=6
		end
		if (input:pressed(i)) then
			c2=7
		else
			c2=6
		end
		rectfill(x,0,x+18,8,c1)
		rectfill(x,10,x+18,18,c2)
	end
end


