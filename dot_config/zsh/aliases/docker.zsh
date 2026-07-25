# ~/.config/zsh/aliases/docker.zsh
# ==============================================================
# Docker & Docker Compose 常用极速别名
# ==============================================================

command -v docker >/dev/null 2>&1 || return 0

# 基础替换
alias d='docker'
alias dc='docker compose'

# 容器状态查看
alias dps='docker ps'
alias dpa='docker ps -a'

# 镜像查看
alias di='docker images'

# 容器操作与调试
alias dex='docker exec -it'            # 进入容器交互终端 (如 dex <container_id> bash)
alias dlog='docker logs'
alias dlogf='docker logs -f'          # 实时跟踪容器日志

# 容器生命周期管理
alias dstart='docker start'
alias dstop='docker stop'
alias drestart='docker restart'

# Docker Compose 常用操作
alias dcup='docker compose up -d'     # 后台启动所有服务
alias dcdown='docker compose down'    # 停止并删除容器、网络和卷
alias dcstop='docker compose stop'    # 仅停止服务容器
alias dcr='docker compose restart'    # 重启服务

# 一键清理 (请谨慎使用 ⚠️)
# 清理所有未使用的容器、网络、镜像以及未挂载的卷
alias dclean='docker system prune -a --volumes'
