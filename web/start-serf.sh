#!/bin/bash

exec serf agent \
    -tag role=web \
    -join $SERF_PORT_7946_TCP_ADDR:$SERF_PORT_7946_TCP_PORT
