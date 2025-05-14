# floatcsep-hermes interface

### Docker Execution

* Build the Docker image:
   ```bash
   docker build \
    --build-arg USER_UID=$(id -u) \
    --build-arg USER_GID=$(id -g) \
    -t floatcsep-hermes .
   ```

* Run the container:
   ```bash
   docker run --rm \
     -u $(id -u):$(id -g) \
     -v $(pwd)/results:/app/results \
     floatcsep-hermes
   ```

## Input Files

In this preliminary interface, forecasts are required to be allocated in the filesystem as:  

```
.
└── forecasts/
    └── {model_a}_{start_time}_{end_time}.csv
    └── {model_b}_{start_time}_{end_time}.csv
    └── ...
├── config.yml
└── ch-region.csv
```

Although, they could also be placed using a volume in the docker run command

## Output

Will create a folder named `results/{start_time}_{end_time}` containing the testing catalog, evaluation `.json` files and evaluation figures. 

## Future Improvements

### Accessing forecasts

A forecast model could be set in the configuration file as:

```yaml
models:
  - etas:
      path: ./  
      class: td
      func: etas.sh
      args_file: args_etas.yml
```

where `etas.sh` (or `etas.py`) could query the Hermes web-app and serializes the forecast into a pycsep readable-object inside the Docker container. 

The `args_file` should be just a `yml`, `json` or `txt` placeholder that `etas.sh` reads, which floatcsep rewrites dynamically for every testing time-windows. This implies, `hermes` only must dynamically modify the floatcsep `config.yml`

### Stream test results

In essence, all we need is that the Docker container spits-out all `./{start_date}_{end_date}/evaluations{TEST}_{MODEL}.json` text for each model. We could modify the docker entrypoint into something

```shell
floatcsep run-stream config.yml
```

such that it streams a chain of JSON (or other) test results

### Region

To test forecasts, it is required to discretize the CH region into cells. We could:

* Write a default CH CSEP region (that goes into `pycsep`), thus going into `config.yml` as:
```yaml
region_config:
  region: ch_csep_region  
```

* `hermes` should serialize its gridded region (with desired resolution) into a file:
```yaml
region_config:
  region: hermes_defined_ch_region.csv
```

### Accessing test catalog (real seismicity)

For now, `floatcsep` queries the SED-FDSN. It is worth discussing whether this is the correct way,
or `hermes` should serialize it into the Docker container.

