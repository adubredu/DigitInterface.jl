function set_locomotion_mode(;host=:sim)
    hostip = host == :sim ? "ws://localhost:8080" : "ws://10.10.1.1:8080"
    WebSockets.open(hostip, subprotocol="json-v1-agility") do ws
        msg = ["request-privilege", Dict("privilege" =>"change-action-command", 
        "priority" => 0)]
        jmsg = json(msg)
        writeguarded(ws, jmsg)
        sleep(5e-3)
        msg = [ "action-set-operation-mode",
            Dict(
                "mode"=> "locomotion"
            )
        ]
        jmsg = json(msg)
        writeguarded(ws, jmsg)
        sleep(5e-3)
    end
end

function set_lowlevel_mode(;host=:sim)
    hostip = host == :sim ? "ws://localhost:8080" : "ws://10.10.1.1:8080"
    WebSockets.open(hostip, subprotocol="json-v1-agility") do ws
        msg = ["request-privilege", Dict("privilege" =>"change-action-command", 
        "priority" => 0)]
        jmsg = json(msg)
        writeguarded(ws, jmsg)
        sleep(5e-3)
        msg = [ "action-set-operation-mode",
            Dict(
                "mode"=> "low-level-api"
            )
        ]
        jmsg = json(msg)
        writeguarded(ws, jmsg)
        sleep(5e-3)
    end
end