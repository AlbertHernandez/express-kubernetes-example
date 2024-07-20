#!/bin/bash

# ====================================================== #
#                  Private Methods                       #
# ====================================================== #

function _echo() {
	echo "$1"
}

function _date_time() {
    date +"%Y/%m/%d %H:%M:%S"
}

function _utc_date_time() {
    date -u +"%Y/%m/%dT%H:%M:%SZ"
}

function _log() {
    local function_name date_time msg level
    msg="$1"
    level="${2:-${FUNCNAME[1]}}"
    date_time=$(_date_time)
    function_name="${FUNCNAME[2]}"
    _echo "[$date_time][$level]($function_name) $msg"
}

function _CTX() {
    local ctx ctx_name ctx_type

    ctx_name="${FUNCNAME[2]}"

    if [[ $ctx_name == main ]]; then
        ctx_name=$0
        ctx_type="script"
    else
        ctx_type="function"
    fi

    ctx=($ctx_name $ctx_type)

    echo "${ctx[@]}"
}

# ====================================================== #
#                     Public API                         #
# ====================================================== #

function ENTER() {
    local ctx ctx_name date_time
    ctx=($(_CTX))
    DEBUG "${ctx[1]}: ${ctx[0]}"
}

function EXIT() {
    local ctx date_time
    ctx=($(_CTX))
    DEBUG "${ctx[1]}: ${ctx[0]}"
}

function DEBUG() {
    _log "$1"
}

function INFO() {
    _log "$1"
}

function WARN() {
    _log "$1"
}

function ERROR() {
    _log "$1"
}
