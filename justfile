learn-representations *ARGS="":
    poetry run python main.py \
    --batch_size 512 \
    --model resnet18 \
    --dataset cifar10 \
    --mem_size 200 \
    --epochs 100 \
    --start_epoch 500 \
    --learning_rate 0.5 \
    --temp 0.5 \
    --current_temp 0.2 \
    --past_temp 0.01 \
    --cosine \
    {{ ARGS }}

eval-linear:
    poetry run python main_linear_buffer.py \
    --learning_rate 1 \
    --target_task 4 \
    --ckpt ./save_random_200/cifar10_models/cifar10_32_resnet18_lr_0.5_decay_0.0001_bsz_512_temp_0.5_trial_0_500_100_0.2_0.01_1.0_cosine_warm/ \
    --logpt ./save_random_200/logs/cifar10_32_resnet18_lr_0.5_decay_0.0001_bsz_512_temp_0.5_trial_0_500_100_0.2_0.01_1.0_cosine_warm/

# Run just task in the background (env vars enabled)
daemon TASK *ARGS="":
    nohup just {{ TASK }} {{ ARGS }} \
    > {{ snakecase(TASK + "__" + ARGS) }}.log 2>&1 &

kill PROC_NAME="continual_learning":
    kill -9 $(pgrep -f {{ PROC_NAME }})
