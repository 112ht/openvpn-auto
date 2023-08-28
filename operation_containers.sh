        reboot_docker_container
        ;;
    con_vpn_docker_container)
        con_vpn_docker_container
        ;;
    rm_docker_container)
        rm_docker_container
        ;;
    copy_testscript_docker_container)
        copy_testscript_docker_container
        ;;
    execute_testfile_docker_container)
        execute_testfile_docker_container
        ;;
    stop_testfile_docker_container)
        stop_testfile_docker_container
        ;;
    stop_vpn_docker_container)
        stop_vpn_docker_container
        ;;


    *)
        echo "引数不正"
        exit 1
        ;;
esac
echo "openvpn接続用container操作終了"
                                                                     
