use std::fs::File;
use std::io::BufRead;

fn main() {
    let file = std::io::BufReader::new(File::open(std::env::args().nth(1).unwrap()).unwrap());
    let mut sum = 0;
    for line in file.lines() {
        let line = line.unwrap();
        let mut it = line.split(' ');
        let mut pattern = it
            .next()
            .unwrap()
            .chars()
            .map(|x| x.into())
            .collect::<Vec<_>>();
        let mut groups = it
            .next()
            .unwrap()
            .split(',')
            .map(|x| x.parse().unwrap())
            .collect::<Vec<_>>();

        use std::iter::repeat;
        pattern = repeat(pattern.iter().chain(std::iter::once(&Unknown)))
            .take(5)
            .flatten()
            .cloned()
            .collect();
        groups = repeat(groups.iter()).take(5).flatten().cloned().collect();
        sum += solve(&pattern[..pattern.len() - 1], &groups);
    }

    println!("{}", sum);
}

#[derive(PartialEq, Debug, Clone)]
enum SpringStatus {
    Unknown,
    Broken,
    Operational,
}
use SpringStatus::*;

impl From<char> for SpringStatus {
    fn from(c: char) -> SpringStatus {
        match c {
            '?' => Unknown,
            '#' => Broken,
            '.' => Operational,
            _ => unreachable!(),
        }
    }
}

fn brute(i: usize, springs: &mut [SpringStatus], groups: &[usize]) -> u64 {
    if i == springs.len() {
        return if springs
            .split(|x| *x == Operational)
            .map(|x| x.len())
            .filter(|x| *x != 0)
            .collect::<Vec<_>>()
            == groups
        {
            1
        } else {
            0
        };
    }
    if springs[i] == Unknown {
        springs[i] = Operational;
        let mut res = brute(i + 1, springs, groups);
        springs[i] = Broken;
        res += brute(i + 1, springs, groups);
        springs[i] = Unknown;
        return res;
    }
    brute(i + 1, springs, groups)
}

fn solve(pattern: &[SpringStatus], groups: &[usize]) -> u64 {
    let mut solution = vec![0u64; pattern.len() * groups.len()];

    let mut index = |p, g| p * groups.len() + g;

    for start in (0..pattern.len()).rev() {
        for group_start in (0..groups.len()).rev() {
            if (pattern[start] == Operational || pattern[start] == Unknown)
                && start != pattern.len() - 1
            {
                solution[index(start, group_start)] += solution[index(start + 1, group_start)];
            }
            if pattern[start] == Broken || pattern[start] == Unknown {
                let glen = groups[group_start];
                if start + glen <= pattern.len()
                    && pattern[start..start + glen]
                        .iter()
                        .all(|x| *x != Operational)
                {
                    if group_start == groups.len() - 1 {
                        if !pattern[start + glen..].contains(&Broken) {
                            solution[index(start, group_start)] += 1;
                        }
                    } else if start + glen + 1 < pattern.len() && pattern[start + glen] != Broken {
                        solution[index(start, group_start)] +=
                            solution[index(start + glen + 1, group_start + 1)];
                    }
                }
            }
        }
    }

    solution[index(0, 0)]
}
