function send_torque_command(fallback_opmode, apply_command, τ, v, β)
    llcomms.send_torque_command(fallback_opmode, apply_command, τ, v, β)
end