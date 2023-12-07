#![feature(slice_group_by)]

use core::cmp::Ordering;
use std::fs::File;
use std::io::BufRead;
use Ordering::*;

#[derive(Copy, Clone, PartialEq, Eq, Debug)]
struct Card(char);

impl PartialOrd<Card> for Card {
    fn partial_cmp(&self, other: &Card) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Card {
    fn cmp(&self, other: &Card) -> Ordering {
        if self == other {
            return Equal;
        }

        if self.0 == 'J' {
            return Less;
        }
        if other.0 == 'J' {
            return Greater;
        }

        for suit in ['A', 'K', 'Q', 'T'] {
            if self.0 == suit {
                return Greater;
            }
            if other.0 == suit {
                return Less;
            }
        }
        if self.0 < other.0 {
            return Less;
        } else {
            return Greater;
        }
    }
}

fn main() {
    let file = std::io::BufReader::new(File::open(std::env::args().nth(1).unwrap()).unwrap());
    let mut hands: Vec<([Card; 5], usize)> = file
        .lines()
        .map(|line| parse_line(&line.unwrap()))
        .collect();

    hands.sort_by(|(a, _), (b, _)| hand_type(*a).cmp(&hand_type(*b)).then(a.cmp(b)));
    println!(
        "{}",
        hands
            .iter()
            .enumerate()
            .map(|(i, (_, w))| (i + 1) * w)
            .sum::<usize>()
    )
}

fn hand_type(mut hand: [Card; 5]) -> u8 {
    hand.sort();
    let mut start = 0;
    while start < 5 && hand[start].0 == 'J' {
        start += 1;
    }
    let mut largest = 0;
    let mut second_largest = 0;

    if start < 5 {
        for g in hand[start..].group_by(|a, b| a == b).map(|g| g.len() as u8) {
            if g > largest {
                second_largest = largest;
                largest = g;
            } else if g > second_largest {
                second_largest = g;
            }
        }
    }
    5 * (largest + hand.iter().filter(|x| x.0 == 'J').count() as u8) + second_largest
}

fn parse_line(line: &str) -> ([Card; 5], usize) {
    let [a, b]: [&str; 2] = line.split(' ').collect::<Vec<_>>().try_into().unwrap();
    (
        a.chars().map(Card).collect::<Vec<_>>().try_into().unwrap(),
        b.parse().unwrap(),
    )
}
