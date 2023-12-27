# charts
My custom Helm Chart repository

To build a Helm package use the following command:
```bash
helm package <package-path>
```

After the package has been built, rebuild the index with:
```bash
helm repo index .
```