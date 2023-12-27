# charts
My custom Helm Chart repository

To build a Helm package use the following command:
```shell
helm package <package-path>
```

After the package has been built, rebuild the index with:
```shell
helm repo index .
```

The current repository can be added with the following command:
```shell
helm repo add sebastiandaberdaku https://sebastiandaberdaku.github.io/charts
```
The repository can then be updated with the following command:
```shell
helm repo update sebastiandaberdaku
```

To view the available charts in the repository you can use:
```shell
helm search repo sebastiandaberdaku
```