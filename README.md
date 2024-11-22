# HALOs on Matlaber
First use Remote-SSH vscode esxtension to ssh in. You san set the host name to `matlaber6.mit.edu`

## Docker
Build the container
```
docker build -t halos_env .
```
Run the container
replace `~/UROP/HALOs-workspace/home` with local path to `HALOs-workspace/home` 
```
docker run -d   --name halos_container   -v ~/UROP/HALOs-workspace/home:/home   halos_env   bash -c "tail -f /dev/null"
```
Enter the container
```
docker exec -it halos_container /bin/bash
```

If you ever need to restart the container you can use:
```
docker stop halos_container
docker rm halos_container
```

Now just do everything in the home directory

# Test HALOs
run conda init inside the container before you do anything else. 
```
conda init
```
Also make sure to start up a new shell by opening a new terminal window and running
```
docker exec -it halos_container /bin/bash
```

```
cd home/HALOs
```

```
. install.sh
```

Go back to `home/HALOs` and Make sure to run this line intead inside `home/HALOs`
```
accelerate launch \
  --config_file accelerate_config/fsdp_8gpu.yaml \
  --main_process_port 29500 \
  launch.py \
  loss=kto \
  model=llama \
  datasets="[ultrabin,shp]" \
  exp_name=llama3-8b_sft_dummy-kto \
  ++cache_dir=/data/models \
  ++model.name_or_path=meta-llama/Meta-Llama-3-8B \
  ++model.load_from=/data/models/llama3-8b_sft/FINAL/ \
  ++lr=5e-6 \
  ++loss.beta=0.1
```


# Supervised Finetune on HALOs
1. Copy the `gpt2.yaml` file to the `HALOs/config/model/` folder.
2. scp the `tokenized-events-TrainShuffled.txt` and `tokenized-events-Validation.txt` to the `data/` folder in the container.
3. Add this function to `dataloader.py` in the `HALOs/train/` folder:
```
def get_foo(split: str, *args, **kwargs) -> Dataset:
```


4. `cd home` and run the following command:
```
accelerate launch \
  --config_file accelerate_config/fsdp_8gpu.yaml \
  --main_process_port 29500 \
  HALOs/launch.py \
  loss=sft \
  model=gpt2 \
  datasets="[ultrabin,shp]" \
  exp_name=gpt2-music-small\
  ++cache_dir=/data/models \
  ++model.name_or_path=stanford-crfm/music-small-800k \
  ++lr=5e-6 \
```


