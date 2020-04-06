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

inputtst={}
setmetatable(inputtst,inputtst)
function inputtst:allbuttons()
	return 0
end
function inputtst:button(i)
	return false
end
function inputtst:time()
	return 1
end

function _init()
	input:init()
	inputtst.__index=input
	testresult=""
	input:init()
	cls()
end

function _update()
	input:update()
end

function _draw()
	cls(0)
	if testresult=="" then
		print("unit tests passed",0,0,11)
	else
		print("test results",0,40,7)
		print(testresult,0,46)
		print("unit tests failed",0,0,8)
	end
	print("button status",0,6,7)
	print("button actions",0,20,7)
	local i
	for i=1,6 do
		local c1,c2
		if input:state(i) then
			c1=10
		else
			c1=6
		end
		if input:pressednow(i) then
			c2=11
		elseif input:actionnow(i) then
			c2=12
		elseif input:releasednow(i) then
			c2=8
		else
			c2=6
		end

		local x=((i-1)*10)
		rectfill(x,12,x+8,18,c1)
		print(sub("⬅️➡️⬆️⬇️🅾️❎",i,i),x+1,13,0)
		rectfill(x,26,x+8,32,c2)
		print(sub("⬅️➡️⬆️⬇️🅾️❎",i,i),x+1,27,0)
	end
end
