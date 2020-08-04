#!/bin/bash

project_name=$1
install_dependencies=$2

if [[ "$install_dependencies" == "True" ]]; then
	PKGS=("python3" "python3-venv" "python3-pip")
	INSTALL_EXEC=""
	for value in "${PKGS[@]}"; do
		is_installed=$(dpkg -S $value 2>&1)

		if [[ "$is_installed" == *"no path"* ]]; then
			INSTALL_EXEC+=" $value"
		fi
	done

	if [ -z INSTALL_EXEC ]; then
		echo "Missing Packages: apt-get install$INSTALL_EXEC"
		exit 1
	fi
fi

python3 -m venv $PWD/venv

source "$PWD/venv/bin/activate"

pip install --upgrade pip wheel

pip install -r requirements.txt
django-admin startproject $project_name

$PWD/$project_name/manage.py migrate
echo "$1 Configuration Complete: . ./venv/bin/activate to begin"
