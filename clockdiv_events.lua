-- 01: pseudorandom CVs + trigger pulse

count = 0 --init count
output[1].slew  = 0.2
output[2].slew = 0.2
output[3].slew = 0.2

function randCV(n) --generate random CV value and send to output "n"
  local voltage = (math.random() * 5)
  output[n].volts = voltage
print("CV" .. n .. ": " .. voltage)
end

function Pulse() -- send 10ms pulse/trigger signal to output 4

  output[4].volts = 5
  clock.run(function()
    clock.sleep(0.01)
    output[4].volts = 0
  end)
end


input[1].change = function()
  count = count + 1
    if ((count % 4) == 0) then -- clock-divided instruction execution with modulo operator
        randCV(1)
    end
    if ((count % 8) == 0) then
        randCV(2)
    end
    if ((count % 16) == 0) then
        randCV(3)
    end
    if ((count % 64) == 0) then
        Pulse()
        print("PULSE + RESET")
        count = 0 --reset count
    end
end

-- Set input 1 to detect rising clock edges
input[1].mode('change', 1.0)


